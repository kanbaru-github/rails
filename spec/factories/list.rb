FactoryBot.define do
  # 宣言文でありデータの定義を行う際に記述します。
  factory :list do
    # どのモデルに対してデータ定義を行うのか記します。
    title { Faker::Lorem.characters(number:10) }
    # Faker:: ：Fakerを使用する時の宣言
    # Lorem：ダミーテキストタイプを選択　※Lorem=lorem ipsumの略でダミーテキストの意味
    # characters：文字列を作成
    # number：生成文字数の指定
    body { Faker::Lorem.characters(number:30) }
  end
end