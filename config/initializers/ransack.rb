# Initializer to hack Arel and make it include Arel::OrderPredications so `.desc` will work.
# https://github.com/activerecord-hackery/ransack/issues/483#issuecomment-184196535
# @todo Do we need this in Rails 5?
class Arel::Nodes::NamedFunction
    include Arel::OrderPredications
end
