defmodule CraftersWeb.PageView do
  use CraftersWeb, :view

  def count_votes(month, date, timeslot) do
    month.preferences
    |> Enum.filter(has_slot(date, timeslot))
    |> Enum.count()
  end

  defp has_slot(date, timeslot) do
    fn(preference) ->
      Enum.any?(preference.slots, fn(slot) -> slot.date == date && slot.timeslot == timeslot end)
    end
  end

  def day_of_week(date) do
    case Date.day_of_week(date) do
      1 -> "Lun"
      2 -> "Mar"
      3 -> "Mer"
      4 -> "Jeu"
      5 -> "Ven"
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
