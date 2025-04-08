# frozen_string_literal: true

module Spree
  module Api
    class UserGroupsController < Spree::Api::BaseController
      before_action :find_user_group, only: [:show, :update, :destroy]

      def index
        authorize! :read, Spree::UserGroup

        @user_groups = Spree::UserGroup.all
        render json: @user_groups.as_json(methods: :price_list)
      end

      def show
        authorize! :read, @user_group

        render json: @user_group.as_json(methods: :price_list)
      end

      def create
        authorize! :create, Spree::UserGroup

        @user_group = Spree::UserGroup.new(user_group_params)
        if @user_group.save
          render json: @user_group.as_json(methods: :price_list), status: :created
        else
          render json: @user_group.errors, status: :unprocessable_entity
        end
      end

      def update
        authorize! :update, Spree::UserGroup

        if @user_group.update(user_group_params)
          render json: @user_group.as_json(methods: :price_list), status: :ok
        else
          render json: @user_group.errors, status: :unprocessable_entity
        end
      end

      def destroy
        authorize! :destroy, Spree::UserGroup

        if @user_group.destroy
          render json: { message: "Successfully Destroyed", object: @user_group }, status: :ok
        else
          invalid_resource!(@user_group)
        end
      end

      private

      def find_user_group
        @user_group = Spree::UserGroup.find(params[:id])
      end

      def user_group_params
        params.require(:user_group).permit(permitted_user_group_attributes)
      end
    end
  end
end
