# frozen_string_literal: true

module SolidusAfterpay
  class BaseController < ::Spree::BaseController
    protect_from_forgery unless: -> { request.format.json? }

    rescue_from ::ActiveRecord::RecordNotFound, with: :resource_not_found
    rescue_from ::CanCan::AccessDenied, with: :unauthorized

    private

    def order_token
      cookies.signed[:guest_token]
    end

    def resource_not_found
      respond_to do |format|
        format.html { redirect_to spree.cart_path, notice: I18n.t('solidus_afterpay.resource_not_found') }
        format.json { render json: { error: I18n.t('solidus_afterpay.resource_not_found') }, status: :not_found }
      end
    end

    def unauthorized
      respond_to do |format|
        format.html { redirect_to spree.cart_path, notice: I18n.t('solidus_afterpay.unauthorized') }
        format.json { render json: { error: I18n.t('solidus_afterpay.unauthorized') }, status: :unauthorized }
      end
    end
  end
end
