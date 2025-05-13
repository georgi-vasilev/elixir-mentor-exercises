defmodule Review do
  def get_reviews() do
    [
      %{rating: 5, text: "What a great product, loved it.", date: ~D(2023-01-01)},
      %{rating: 4, text: "Good but could be better.", date: ~D(2023-01-02)},
      %{rating: 3, text: "Average experience.", date: ~D(2023-01-03)},
      %{rating: 2, text: "Not what i expected.", date: ~D(2023-01-04)},
      %{rating: 1, text: "Very poor quality.", date: ~D(2023-01-05)}
    ]
  end

  def get_ratings(reviews) do
    Enum.map(reviews, fn review -> review.rating end)
  end

  def get_average_rating(reviews) do
    reviews
    |> Enum.map(fn review -> review.rating end)
    |> Enum.sum()
    |> divide_reviews(reviews)
  end

  def filter_ratings(reviews, rating) do
    reviews
    |> Enum.filter(fn review -> review.rating >= rating end)
  end

  def date_sorted(reviews) do
    Enum.sort_by(reviews, fn review -> review.date end, :desc)
  end

  def most_common_words(reviews) do
    reviews
    |> word_list()
    |> word_frequences()
    |> top_five()
  end

  defp word_list(reviews) do
    reviews
    |> Enum.flat_map(fn reviews -> String.split(reviews.text) end)
    |> Enum.map(&String.downcase/1)
  end

  defp word_frequences(word_list) do
    word_list
    |> Enum.frequencies()
  end

 defp top_five(word_frequencies) do
    Enum.sort_by(word_frequencies, fn {_, value} -> value end, :desc)
    |> Enum.take(5)
 end

  defp divide_reviews(sum, reviews) do
    sum / length(reviews)
  end
end
