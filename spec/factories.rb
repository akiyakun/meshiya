FactoryGirl.define do
  factory :user do
    name      "Tajima Nenaro"
    email     "nenaro@aqua.com"
    password  "foobar"
    password_confirmation   "foobar"
  end
end
