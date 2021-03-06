class SubjectSetUpdateSchema < JsonSchema
  schema do
    type "object"
    description "A Set of Subjects"
    additional_properties false

    property "display_name" do
      type "string"
    end

    property "metadata" do
      type "object"
    end

    property "links" do
      type "object"

      property "workflows" do
        type "array"
        items do
          type "string", "integer"
        end
      end

      property "subjects" do
        type "array"
        items do
          type "string", "integer"
        end
      end
    end
  end
end
