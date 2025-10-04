FactoryBot.define do
  factory :transaction do
    property { nil }
    buyer { nil }
    seller { nil }
    status { "MyString" }
    transaction_type { "MyString" }
    amount { "9.99" }
    start_date { "2025-10-02" }
    end_date { "2025-10-02" }
  end
end
