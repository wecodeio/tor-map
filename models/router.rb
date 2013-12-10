require_relative "../config/initializers/sequel"

class Router < Sequel::Model
  dataset_module do
    def with_location
      exclude(location: nil)
    end

    def include_location
      with_location.
        select_append{ st_y(st_astext(:location)).as(:latitude) }.
        select_append{ st_x(st_astext(:location)).as(:longitude) }
    end

    def within(distance_in_meters, latitude, longitude)
      with_location.where{ Sequel.function(:ST_Distance, :location, Sequel.lit("ST_GeographyFromText('SRID=4326; POINT(? ?)')", longitude, latitude)) < distance_in_meters }
    end

    def ordered_by_proximity(latitude, longitude)
      select_append{ Sequel.function(:ST_Distance, :location, Sequel.lit("ST_GeographyFromText('SRID=4326; POINT(? ?)')", longitude, latitude)).as(:distance) }.
        order(:distance)
    end
  end

  def latitude
    values[:latitude]
  end

  def longitude
    values[:longitude]
  end

  def distance
    values[:distance]
  end

  def update_location(latitude, longitude)
    update(location: Sequel.lit("ST_GeographyFromText('SRID=4326; POINT(? ?)')", longitude, latitude))
  end
end
