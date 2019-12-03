class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  DEFAULT_PER_PAGE = 20
  DEFAULT_PAGE = 1
  DEFAULT_ORDER_BY = 'created_at'.freeze
  DEFAULT_DIR = 'DESC'

  def self.super_paginate(params = {})
    per_page = validate_value(params[:per_page], DEFAULT_PER_PAGE)
    page     = validate_value(params[:page], DEFAULT_PAGE)
    sorting  = validate_value(params[:sorting], DEFAULT_ORDER_BY)
    dir      = validate_value(params[:dir], DEFAULT_DIR)

    page = 1 if page.to_i <= 0

    sorting = "#{table_name}.#{sorting}" unless sorting.include?('.')

    order("#{sorting} #{dir}").paginate(page: page, per_page: per_page)
  end

  def self.validate_value(value, default)
    return false if value == 'false'
    return default if value == 'undefined'
    return default if value.blank?

    value
  end

end
