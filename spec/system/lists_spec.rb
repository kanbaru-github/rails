# frozen_string_literal: true

require 'rails_helper'

describe '投稿のテスト' do
  let!(:list) { create(:list, title:'hoge',body:'body') }
  # let!とした場合には事前評価になります。
  describe 'トップ画面(top_path)のテスト' do
    before do
      # beforeではitブロックの実行時に都度実行されます。
      # it内で使用しない変数の場合にもbeforeは実行されてしまいます。
      visit top_path
    end
    context '表示の確認' do
      it 'トップ画面(top_path)に「ここはTopページです」が表示されているか' do
        expect(page).to have_content 'ここはTopページです'
        # expect(page)で遷移中のページ全体を期待値としています。
        # have_contentでは指定の値がページ内に含まれているかを判定します。
      end
      it 'top_pathが"/top"であるか' do
        expect(current_path).to eq('/top')
      end
    end
  end

  describe "投稿画面(todolists_new_path)のテスト" do
    before do
      visit todolists_new_path
    end
    context '表示の確認' do
      it 'todolists_new_pathが"/todolists/new"であるか' do
        expect(current_path).to eq('/todolists/new')
      end
      it '投稿ボタンが表示されているか' do
        expect(page).to have_button '投稿'
        # have_buttonではボタンが表示されているかを判定します。
      end
    end
    context '投稿処理のテスト' do
      it '投稿後のリダイレクト先は正しいか' do
        fill_in 'list[title]', with: Faker::Lorem.characters(number:5)
        # fill_inではフォームにテキストを入力します。
        # withの後にはFaker::Lorem.characters(number:5)としていて、5桁のランダムな文字列を入力する形になっています。
        fill_in 'list[body]', with: Faker::Lorem.characters(number:20)
        click_button '投稿'
        expect(page).to have_current_path todolist_path(List.last)
        # have_current_pathでは現在のURLパスを取得します。投稿後のページURLが正しいURLパスであるかを判定しています。
      end
    end
  end

  describe "投稿一覧のテスト" do
    before do
      visit todolists_path
    end
    context '表示の確認' do
      it '投稿されたものが表示されているか' do
        expect(page).to have_content list.title
        expect(page).to have_link list.title
        # have_linkではページの中に文字列にマッチするリンク、マッチするリンクURLが存在するかを判定しています。
      end
    end
  end

  describe "詳細画面のテスト" do
    before do
      visit todolist_path(list)
    end
    context '表示の確認' do
      it '削除リンクが存在しているか' do
        expect(page).to have_link '削除'
      end
      it '編集リンクが存在しているか' do
        expect(page).to have_link '編集'
      end
    end
    context 'リンクの遷移先の確認' do
      it '編集の遷移先は編集画面か' do
        edit_link = find_all('a')[3]
        # find_allでは指定した値（タグ）をページ中から全て検索します。
        # 今回の場合は3番目のaタグをedit_linkに代入しています。
        edit_link.click
        expect(current_path).to eq('/todolists/' + list.id.to_s + '/edit')
        # eqは指定した値が期待値と同値であるかを判定します。
      end
    end
    context 'list削除のテスト' do
      it 'listの削除' do
        expect{ list.destroy }.to change{ List.count }.by(-1)
        # changeの値にList.countとListのデータ数を表し、それがby(-1)とすることで、一つ減っているかという判定をしています。
      end
    end
  end

  describe '編集画面のテスト' do
    before do
      visit edit_todolist_path(list)
    end
    context '表示の確認' do
      it '編集前のタイトルと本文がフォームに表示(セット)されている' do
        expect(page).to have_field 'list[title]', with: list.title
        # have_fieldでは指定した値のフォームが存在するか判定します。
        # 今回の場合はlist[title]というname属性のフォームが存在するかで判定しています。
        expect(page).to have_field 'list[body]', with: list.body
      end
      it '保存ボタンが表示される' do
        expect(page).to have_button '保存'
      end
    end
    context '更新処理に関するテスト' do
      it '更新後のリダイレクト先は正しいか' do
        fill_in 'list[title]', with: Faker::Lorem.characters(number:5)
        fill_in 'list[body]', with: Faker::Lorem.characters(number:20)
        click_button '保存'
        # click_buttonはボタンをクリックします。
        expect(page).to have_current_path todolist_path(list)
      end
    end
  end
end