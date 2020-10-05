FactoryBot.define do
  factory :message do
    content {Faker::Lorem.sentence}
    association :user
    association :room

    after(:build) do |item|
    # afterメソッドは任意の処理の後に指定の処理を実行することができる。
      item.image.attach(io: File.open('public/images/test_image.png'), filename: 'test_image.png')
      # io: File.openに設定したパスのファイル（public/images/test_image.png）を、test_image.pngというファイル名で保存。
    end
  
  end
end