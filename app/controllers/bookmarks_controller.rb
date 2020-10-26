class BookmarksController < ApplicationController
    before_action :authorized, only: [:create]

    def create
    end
end
