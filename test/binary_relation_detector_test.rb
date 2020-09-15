require_relative "test_helper"

class BinaryRelationDetectorTest < Minitest::Test
  def test_directed_by
    detector = Mitie::BinaryRelationDetector.new("#{models_path}/binary_relations/rel_classifier_film.film.directed_by.svm")
    assert_equal "film.film.directed_by", detector.name
    doc = model.doc("The Shawshank Redemption was directed by Frank Darabont and starred Tim Robbins and Morgan Freeman")

    relations = detector.relations(doc)
    assert_equal 1, relations.size

    relation = relations.first
    assert_equal "Shawshank Redemption", relation[:first]
    assert_equal "Frank Darabont", relation[:second]
    assert relation[:score]
  end

  def test_place_founded
    detector = Mitie::BinaryRelationDetector.new("#{models_path}/binary_relations/rel_classifier_organization.organization.place_founded.svm")
    assert_equal "organization.organization.place_founded", detector.name
    doc = model.doc("Google was founded in Menlo Park, CA by Larry Page and Sergey Brin")

    relations = detector.relations(doc)
    assert_equal 1, relations.size

    relation = relations.first
    assert_equal "Google", relation[:first]
    assert_equal "Menlo Park", relation[:second]
    assert relation[:score]
  end

  def test_non_document
    detector = Mitie::BinaryRelationDetector.new("#{models_path}/binary_relations/rel_classifier_film.film.directed_by.svm")
    error = assert_raises(ArgumentError) do
      detector.relations("Hi")
    end
    assert_equal "Expected Mitie::Document, not String", error.message
  end

  def test_missing_file
    error = assert_raises(ArgumentError) do
      Mitie::BinaryRelationDetector.new("missing.dat")
    end
    assert_equal "File does not exist", error.message
  end
end
