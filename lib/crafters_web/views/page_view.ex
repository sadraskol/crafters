defmodule CraftersWeb.PageView do
  use CraftersWeb, :view

  def count_votes(month, activity, date, timeslot) do
    month.preferences
    |> Enum.filter(has_slot(activity, date, timeslot))
    |> Enum.count()
  end

  defp has_slot(activity, date, timeslot) do
    fn(preference) ->
      has_activity = Enum.any?(preference.activities, fn(act) -> act.name == activity end)
      has_timeslot = Enum.any?(preference.slots, fn(slot) -> slot.date == date && slot.timeslot == timeslot end)
      has_activity && has_timeslot
    end
  end

  def included?(date, best_dates) do
    Enum.any?(best_dates, fn(el) -> elem(el, 0) == date end)
  end

  def format_date_inline(date) do
    [ content_tag(:span, day_of_week(date)),
      " ",
      content_tag(:span, date.day),
      " ",
      content_tag(:span, month_of_year(date))]
  end

  def day_of_week(date) do
    case Date.day_of_week(date) do
      1 -> "Lun"
      2 -> "Mar"
      3 -> "Mer"
      4 -> "Jeu"
      5 -> "Ven"
      6 -> "Sam"
      7 -> "Dim"
    end
  end

  def month_of_year(date) do
    case date.month do
      1 -> "Janv."
      2 -> "Févr."
      3 -> "Mars"
      4 -> "Avr."
      5 -> "Mai"
      6 -> "Juin"
      7 -> "Juil."
      8 -> "Août"
      9 -> "Sept."
      10 -> "Oct."
      11 -> "Nov."
      12 -> "Déc."
    end
  end
end
