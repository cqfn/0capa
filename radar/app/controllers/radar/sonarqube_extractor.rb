# frozen_string_literal: true

require "http"
require "json"
require "nokogiri"
require_relative "metrics_base_extractor"

class SonarqubeExtractor < MetricsBaseController
  SORUCE = "sonarqube"

  def initialize
    puts "initialize SonarqubeExtractor"
    Initialize(SORUCE)
  end

  def runAnalysis
    # processing those repositories that had been downloaded and run the sonarqube analysis
    # TODO: implment a feature to handle repositories with multiple projects

    #TOOD: Comment status on the code
    TomPushInfo.where(status: "D").each do |pushInfo|
      dir_name = "./tmp/github_" + pushInfo.head_commit_id + "/" + pushInfo.repo_name

      #check if there is a project created on sonarqube
      url = "http://188.130.155.202:7000/api/projects/search?projects=" + pushInfo.full_name
      response = HTTP["Content-Type": "JSON", "Content-Language": "en-US", "Authorization": "Basic #{@extractor_seetings.apisecret}"].get(
        url
      )

      sonar_project = nil
      if response.code == 200
        json = JSON.parse(response)
        sonar_project = json["components"][0]
      end

      #Creating the sonarqube project in case it does not exist
      if sonar_project == nil
        url = "http://188.130.155.202:7000/api/projects/create?visibility=private&name=" + pushInfo.full_name + "&project=" + pushInfo.full_name
        response = HTTP["Content-Type": "JSON", "Content-Language": "en-US", "Authorization": "Basic #{@extractor_seetings.apisecret}"].post(
          url
        )

        if response.code == 200
          json = JSON.parse(response)
          sonar_project = json["project"]

          url = "http://188.130.155.202:7000/api/webhooks/create?name=wh_" + pushInfo.full_name + "&project=" + pushInfo.full_name + "&url=https://tom-radar.herokuapp.com/api/v1/webhook?source=sonarqube"
          response = HTTP["Content-Type": "JSON", "Content-Language": "en-US", "Authorization": "Basic #{@extractor_seetings.apisecret}"].post(
            url
          )
        else
          # error in project creation
          raise "It was a error creating sonarqube project by TOM"
        end
      end

      puts JSON.pretty_generate(sonar_project)

      case pushInfo.language.downcase
      when "java"
        command = _prepare_java_repo(dir_name, pushInfo.repo_name)
        puts command
        # Running maven/gradle command to scan the project
        Dir.chdir(dir_name) {
          %x[#{command}]
        }
        pushInfo.status = "S"
        pushInfo.save
      when "ruby"
      else
        puts "Language no supported"
      end
    end
  end

  def get_last_update(json)
    # puts JSON.pretty_generate(json)

    metrics = "new_technical_debt,blocker_violations,bugs,classes,code_smells,complexity_in_classes,branch_coverage,coverage,violations,line_coverage,lines,ncloc,sqale_rating,major_violations,minor_violations,new_blocker_violations,new_bugs,new_code_smells,new_critical_violations,new_major_violations,new_minor_violations,new_security_hotspots,new_vulnerabilities,alert_status,reliability_rating,reopened_issues,security_hotspots,new_security_hotspots_reviewed,security_rating"

    url = "http://188.130.155.202:7000/api/measures/component?component=" + json["project"]["key"] + "&metricKeys=" + metrics
    response = HTTP["Content-Type": "JSON", "Content-Language": "en-US", "Authorization": "Basic #{@extractor_seetings.apisecret}"].get(
      url
    )
    # puts "analysis reponse code"
    # puts response.code
    # puts @extractor_seetings.apisecret
    # puts "analysis reponse code end"
    if response.code == 200
      analysis = TomAnalysis.new(
        extractor_id: SORUCE,
        repo_name: json["project"]["key"],
      )
      if analysis.save
        analysis_response = JSON.parse(response)
        # puts analysis.inspect
        # puts analysis.id
        measures = analysis_response["component"]["measures"]

        measures.each {
          |measure|
          puts measure
          m = TomAnalysisMetric.new(
            analysis_id: analysis.id,
            metric_name: measure["metric"],
          )

          if measure["value"]
            m.value = measure["value"]
            m.is_best_value = measure["bestValue"] ? "true" : "false"
          elsif measure["period"]
            m.value = measure["period"]["value"]
            m.is_best_value = measure["period"]["bestValue"] ? "true" : "false"
          end
          m.save
        }
        # puts JSON.pretty_generate(measures)
      end
    end
    # TomAnalysisMetric
    # puts "response"
    # puts JSON.pretty_generate(JSON.parse(response))
    # puts response.code
    # puts "response end"

    true
  end

  # defining a mehtod to prepare repositories based on its main language
  def _prepare_java_repo(repo_path, repo_name)
    puts "analysing directory -> " + repo_path
    # flow for projects based on maven
    if File.exists?(repo_path + "/pom.xml")
      puts "maven project detected"
      xml = File.open(repo_path + "/pom.xml")
      pom = Nokogiri::XML(xml)

      dependencies_set = pom.css("project dependencies dependency artifactId")

      isScannerFound = false

      dependencies_set.each do |dep|
        puts dep.content
        if dep.content.downcase == "sonar-maven-plugin"
          isScannerFound = true
          puts "sonarqube scanner found"
          break
        end
      end

      if !isScannerFound
        puts "No sonarqube scanner found, it will be included automatically"
        dependencies = pom.at_css "dependencies"
        dependencies.add_child "
       <dependency>
           <groupId>org.sonarsource.scanner.maven</groupId>
           <artifactId>sonar-maven-plugin</artifactId>
           <version>3.0.1</version>
       </dependency>
       "
        File.write(repo_path + "/pom.xml", pom)
      end

      command = "mvn sonar:sonar -Dsonar.projectKey=" + repo_name + " -Dsonar.host.url=http://188.130.155.202:7000  -Dsonar.login=" + @extractor_seetings.apikey
    elsif File.exists?(repo_path + "/build.gradle")
      puts "gradle project detected"
    else
      raise "no package manager detected or it's not supported"
    end
  end
end
