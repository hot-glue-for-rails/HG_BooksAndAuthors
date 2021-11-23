require 'rails_helper'

describe "interaction for BooksController", type: :feature do
  include HotGlue::ControllerHelper
  
    let!(:author1) {create(:author, name: FFaker::Name.name)}
  let!(:book1) {create(:book , name: FFaker::Movie.title, 
      blurb: FFaker::Movie.title, 
      long_description:  FFaker::Lorem.paragraphs(10).join(), 
      cost: rand(1)*10000, 
      how_many_printed: rand(100), 
      approved_at: DateTime.current + rand(1000).seconds, 
      release_on: Date.current + rand(50).days, 
      time_of_day: Time.current + rand(5000).seconds, 
      selected: !!rand(2).floor )}
   

  describe "index" do
    it "should show me the list" do
      visit books_path





      expect(page).to have_content(book1.how_many_printed)
      expect(page).to have_content(book1.approved_at.in_time_zone(current_timezone).strftime('%m/%d/%Y @ %l:%M %p ').gsub('  ', ' ') + timezonize(current_timezone)  )




    end
  end

  describe "new & create" do
    it "should create a new Book" do
      visit books_path
      click_link "New Book"
      expect(page).to have_selector(:xpath, './/h3[contains(., "New Book")]')

      new_name = 'new_test-email@nowhere.com' 
      find("[name='book[name]']").fill_in(with: new_name)
      author_id_selector = find("[name='book[author_id]']").click 
      author_id_selector.first('option', text: author1.name).select_option
      new_blurb = 'new_test-email@nowhere.com' 
      find("[name='book[blurb]']").fill_in(with: new_blurb)
      new_long_description = 'new_test-email@nowhere.com' 
      find("[name='book[long_description]']").fill_in(with: new_long_description)
      new_cost = 'new_test-email@nowhere.com' 
      find("[name='book[cost]']").fill_in(with: new_cost)
      new_how_many_printed = rand(10) 
      find("[name='book[how_many_printed]']").fill_in(with: new_how_many_printed)
      new_approved_at = DateTime.current + (rand(100).days) 
      find("[name='book[approved_at]']").fill_in(with: new_approved_at)
      new_release_on = 'new_test-email@nowhere.com' 
      find("[name='book[release_on]']").fill_in(with: new_release_on)
      new_time_of_day = 'new_test-email@nowhere.com' 
      find("[name='book[time_of_day]']").fill_in(with: new_time_of_day)
     new_selected = rand(2).floor 
     find("[name='book[selected]'][value='#{new_selected}']").choose
      list_of_genre = Book.defined_enums['genre'].keys 
      new_genre = list_of_genre[rand(list_of_genre.length)].to_s 
      find("select[name='book[genre]']  option[value='#{new_genre}']").select_option
      click_button "Save"
      expect(page).to have_content("Successfully created")

      expect(page).to have_content(new_name)
      expect(page).to have_content(new_blurb)
      expect(page).to have_content(new_long_description)
      expect(page).to have_content(new_cost)
      expect(page).to have_content(new_how_many_printed)
            expect(page).to have_content(new_approved_at.in_time_zone(current_timezone).strftime('%m/%d/%Y')  + " @ " +
      new_approved_at.in_time_zone(current_timezone).strftime('%l').strip + ":" +
      new_approved_at.in_time_zone(current_timezone).strftime('%M %p').strip + " " +
      timezonize(current_timezone))
      expect(page).to have_content(new_release_on)
      expect(page).to have_content(new_time_of_day)
      expect(page).to have_content(new_selected)
      expect(page).to have_content(new_genre)

    end
  end


  describe "edit & update" do
    it "should return an editable form" do
      visit books_path
      find("a.edit-book-button[href='/books/#{book1.id}/edit']").click

      expect(page).to have_content("Editing #{book1.name || "(no name)"}")
      new_name = FFaker::Lorem.paragraphs(1).join 
      find("input[name='book[name]']").fill_in(with: new_name)

      new_blurb = FFaker::Lorem.paragraphs(1).join 
      find("input[name='book[blurb]']").fill_in(with: new_blurb)
      new_long_description = FFaker::Lorem.paragraphs(3).join 
      find("textarea[name='book[long_description]']").fill_in(with: new_long_description)
     new_cost = rand(1)*5000 
     find("[name='book[cost]']").fill_in(with: new_cost)
     new_how_many_printed = rand(10000).floor 
     find("[name='book[how_many_printed]']").fill_in(with: new_how_many_printed)

     new_release_on = Date.current + rand(100).days 
     find("[name='book[release_on]']").fill_in(with: new_release_on)
     new_time_of_day = Time.current + rand(144).hours 
     find("[name='book[time_of_day]']").fill_in(with: new_time_of_day)
     new_selected = rand(2).floor 
     find("[name='book[selected]'][value='#{new_selected}']").choose
      list_of_genre = Book.defined_enums['genre'].keys 
      new_genre = list_of_genre[rand(list_of_genre.length)].to_s 
      find("select[name='book[genre]']  option[value='#{new_genre}']").select_option
      click_button "Save"
      within("turbo-frame#book__#{book1.id} ") do


        expect(page).to have_content(new_name)
        expect(page).to have_content(new_blurb)
        expect(page).to have_content(new_long_description)
        expect(page).to have_content(new_cost)
        expect(page).to have_content(new_how_many_printed)
        expect(page).to have_content(new_genre)

      end
    end
  end

  describe "destroy" do
    it "should destroy" do
      visit books_path
      accept_alert do
        find("form[action='/books/#{book1.id}'] > input.delete-book-button").click
      end
#      find("form[action='/books/#{book1.id}'] > input.delete-book-button").click

      expect(page).to_not have_content(book1.name)
      expect(Book.where(id: book1.id).count).to eq(0)
    end
  end
end

