require_relative './base'

module FavroApi
  module DataTypes
    class Column < ComplexType

      field :columnId,        String
      field :organizationId,  String
      field :widgetCommonId,  String
      field :name,            String
      field :position,        Integer
    end
  end
end
