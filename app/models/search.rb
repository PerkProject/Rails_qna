class Search

  OBJECTS = %w(everywhere answers questions comments users)

  def self.find(query, object)
    return [] unless OBJECTS.include? object
    query = ThinkingSphinx::Query.escape(query)
    return ThinkingSphinx.search("*#{query}*") if object == 'everywhere'
    object.classify.constantize.search("*#{query}*")
  end
end
