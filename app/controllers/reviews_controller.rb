class ReviewsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_property

  def create
    @review = @property.reviews.build(review_params)
    @review.user = current_user

    if @review.save
      redirect_to @property, notice: "Review was successfully created."
    else
      redirect_to @property, alert: "Unable to create review: #{@review.errors.full_messages.join(', ')}"
    end
  end

  def destroy
    @review = @property.reviews.find(params[:id])
    if @review.user == current_user
      @review.destroy
      redirect_to @property, notice: "Review was successfully deleted."
    else
      redirect_to @property, alert: "You are not authorized to delete this review."
    end
  end

  private

  def set_property
    @property = Property.find(params[:property_id])
  end

  def review_params
    params.require(:review).permit(:rating, :comment)
  end
end


