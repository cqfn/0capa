class UpdateTomProjectMetrics < ActiveRecord::Migration[6.1]
  def change
    reversible do |dir|
      dir.up do
        # add a CHECK constraint
        execute <<-SQL
          ALTER TABLE tom_project_metrics
          ALTER COLUMN wf_avg_success_duration TYPE double precision USING wf_avg_success_duration::double precision,
          ALTER COLUMN wf_avg_failure_duration TYPE double precision USING wf_avg_success_duration::double precision,
          ALTER COLUMN wf_avg_successes_per_day TYPE double precision USING wf_avg_success_duration::double precision,
          ALTER COLUMN wf_avg_successes_per_day_real TYPE double precision USING wf_avg_success_duration::double precision,
          ALTER COLUMN wf_avg_fails_per_day TYPE double precision USING wf_avg_success_duration::double precision;
        SQL
      end
      dir.down do
        execute <<-SQL
          ALTER TABLE tom_project_metrics
          ALTER COLUMN wf_avg_success_duration TYPE varchar,
          ALTER COLUMN wf_avg_failure_duration TYPE varchar,
          ALTER COLUMN wf_avg_successes_per_day TYPE varchar,
          ALTER COLUMN wf_avg_successes_per_day_real TYPE varchar,
          ALTER COLUMN wf_avg_fails_per_day TYPE varchar;
        SQL
      end
    end
  end
end
