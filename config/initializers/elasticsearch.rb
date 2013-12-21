require 'elasticsearch'

$es = Elasticsearch::Client.new

unless $es.indices.exists index: "shizuka"
  $es.indices.create index: "shizuka", body: {
    mappings: {
      place: {
        properties: {
          location: {
            type: "geo_shape",
            precision: "10m"
          }
        }
      }
    }
  }
end

