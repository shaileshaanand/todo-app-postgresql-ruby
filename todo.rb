require "active_record"

class Todo < ActiveRecord::Base
  def due_today?
    due_date == Date.today
  end

  def overdue?
    due_date < Date.today
  end

  def due_later?
    due_date > Date.today
  end

  def to_displayable_string
    display_status = completed ? "[X]" : "[ ]"
    display_date = due_today? ? nil : due_date
    "#{id}. #{display_status} #{todo_text} #{display_date}"
  end

  def self.to_displayable_list
    all.map { |todo| todo.to_displayable_string }
  end

  def self.show_list
    puts "My Todo-list\n\nOverdue"
    all.
      where("due_date < ?", Date.today).
      map { |todo| puts todo.to_displayable_string }
    puts "\n\nDue Today"
    all.
      where(due_date: Date.today).
      map { |todo| puts todo.to_displayable_string }
    puts "\n\nDue Later"
    all.
      where("due_date > ?", Date.today).
      map { |todo| puts todo.to_displayable_string }
  end

  def self.add_task(todo_hash)
    self.create!(
      todo_text: todo_hash[:todo_text],
      due_date: Date.today + todo_hash[:due_in_days],
    )
  end

  def self.mark_as_complete!(todo_id)
    todo = self.find(todo_id)
    todo.completed = true
    todo.save
    todo
  end
end
