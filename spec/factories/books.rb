FactoryBot.define do
  factory :book do
    name { "MyString" }
    author_id { 1 }
    blurb { "MyString" }
    long_description { "MyText" }
    cost { 1.5 }
    how_many_printed { 1 }
    approved_at { "2021-11-23 11:13:25" }
    release_on { "2021-11-23" }
    time_of_day { "2021-11-23 11:13:25" }
    selected { false }
    genre { "" }
  end
end
