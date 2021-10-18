require 'rails_helper'

RSpec.describe 'Movies Index Page' do
  before :each do
    @user = create(:mock_user)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)

    visit movies_path
  end

  describe 'show movie results' do
    it 'displays all the search functions' do

      expect(page).to have_content("Welcome #{@user.first_name}!")
      expect(page).to have_button('Find Top Rated Movies')
      expect(page).to have_field('Search by movie title')
      expect(page).to have_button('Find Movies')
    end

    it 'displays the top 40 rated movie results when there is not param present' do

      click_on 'Find Top Rated Movies'

      stub_top_forty_rated_movies

      expect(current_path).to eq(movies_path)
      expect(page).to have_content("Dilwale Dulhania Le Jayenge")
      expect(page).to have_content("8.7")
      expect(page).to have_content("The Shawshank Redemption")
      expect(page).to have_content("8.5")
    end

    it 'displays the movie results when search by title' do

      fill_in("query", with: "Cruella")

      click_button("Find Movies")

      stub_search_movie_by_title

      expect(page).to_not have_content("Dilwale Dulhania Le Jayenge")
      expect(page).to_not have_content("The Shawshank Redemption")
      expect(page).to have_content("Cruella")
      expect(page).to have_content("Cruella 2")
      expect(page).to have_content("A Christmas Cruella")
      expect(page).to have_content("Mega Mindy - Della Cruella")
    end

    it 'displays no movies when no matched results' do

      fill_in :query, with: 'djhfuerskfggdsjhfgdjdk'

      click_button 'Find Movies'

      expect(current_path).to eq(movies_path)
      expect(page).to have_no_content("Cruella")
    end

    it 'redirect user to that movie show page when click on movie link' do

      expect(current_path).to eq(movies_path)

      fill_in("query", with: "Cruella")
      click_button("Find Movies")

      click_link "Cruella"

      expect(current_path).to eq("/movies/337404")
      expect(page).to have_content("Cruella")
      expect(page).to_not have_content("Cruella 2")
      expect(page).to have_content("Vote Average")
      expect(page).to have_content("Runtime")
      expect(page).to have_content("Genre(s)")
      expect(page).to have_content("Cast")
    end
  end
end
