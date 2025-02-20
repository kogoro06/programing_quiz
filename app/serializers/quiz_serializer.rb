# app/serializers/quiz_serializer.rb
class QuizSerializer
  include FastJsonapi::ObjectSerializer
  
  attributes :title
end