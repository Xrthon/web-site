class CartsController < ApplicationController
  before_action :set_cart, only: [:show, :edit, :update]

  def index
    @carts = Current.user.carts
  end

  def show
  end

  def edit
  end

  def update
    if @cart.update(cart_params)
      redirect_to @cart, notice: "Panier mis à jour."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_cart
    @cart = Current.user.carts.find(params[:id])
  end

  def cart_params
    params.require(:cart).permit(:status)
  end
end