# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :event do
    sequence(:title) { |n| "Event#{n}" }
    description "MyString"
    location "MyString"
    date_start DateTime.now
    date_end DateTime.now + 1.hour
    date_limit "2014-04-02 23:16:43"
    created_at "2014-04-02 23:16:43"
    updated_at "2014-04-02 23:16:43"
    tags {[create(:tag)]}
    association :creator
  end

  factory :invalid_event, parent: :event do
    title "T"*300
    description "D"*300
    location "MyString"
    date_limit "2014-04-02 23:16:43"
    created_at "2014-04-02 23:16:43"
    updated_at "2014-04-02 23:16:43"
  end
end
