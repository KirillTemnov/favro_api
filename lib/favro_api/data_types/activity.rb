require_relative './base'

module FavroApi
  module DataTypes
    class Activity < ComplexType

      field :byUserId,          String
      field :time,              String
      field :type,              String
      field :source,            String
      field :cardId,            String
      field :cardName,          String
      field :cardCommonKey,     String
      field :organizationId,    String
    end
  end
end
