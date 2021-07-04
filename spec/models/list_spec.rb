# frozen_string_literal: true
# 文字列をfreezeさせています。
# freezeとはオブジェクトの破壊的な変更ができなくなります。

require 'rails_helper'
# これはspec/rails_helper.rbを読み込んでいます。設定などを行うファイルです。

describe 'モデルのテスト' do
  it "有効な投稿内容の場合は保存されるか" do
    expect(FactoryBot.build(:list)).to be_valid
    # listのデータを作成されることを期待値として、be_validで有効かを判定しています。
  end
end