module DashboardHelper
  def task_time_for_current_user(task_time_id)
    task_time = TaskTime.find(task_time_id)
    return task_time unless task_time.nil? || task_time.user_id != current_user.id
    yield "The Task Time is not associated with you"
  rescue ActiveRecord::RecordNotFound
    yield "The Task Time could not be found"
  end

  def force_task_stop(task_times)
    start_time = task_times.start_time
    duration = task_times.duration || 0
    duration += ((DateTime.now - DateTime.parse(start_time.to_s(:rfc822))) * 24 * 60 * 60).to_i
    task_times.duration = duration
    task_times.start_time = nil
    task_times.save
  end
end
