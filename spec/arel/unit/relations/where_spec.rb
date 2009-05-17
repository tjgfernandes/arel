require File.join(File.dirname(__FILE__), '..', '..', '..', 'spec_helper')

module Arel
  describe Where do
    before do
      @relation = Table.new(:users)
      @predicate = @relation[:id].eq(1)
    end

    describe '#initialize' do
      it "manufactures nested where relations if multiple predicates are provided" do
        another_predicate = @relation[:name].lt(2)
        Where.new(@relation, @predicate, another_predicate). \
          should == Where.new(Where.new(@relation, another_predicate), @predicate)
      end
    end

    describe '#to_sql' do
      describe 'when given a predicate' do
        it "manufactures sql with where clause conditions" do
          sql = Where.new(@relation, @predicate).to_sql

          adapter_is :mysql do
            sql.should be_like(%Q{
              SELECT `users`.`id`, `users`.`name`
              FROM `users`
              WHERE `users`.`id` = 1
            })
          end

          adapter_is_not :mysql do
            sql.should be_like(%Q{
              SELECT "users"."id", "users"."name"
              FROM "users"
              WHERE "users"."id" = 1
            })
          end
        end
      end

      describe 'when given a string' do
        it "passes the string through to the where clause" do
          sql = Where.new(@relation, 'asdf').to_sql

          adapter_is :mysql do
            sql.should be_like(%Q{
              SELECT `users`.`id`, `users`.`name`
              FROM `users`
              WHERE asdf
            })
          end

          adapter_is_not :mysql do
            sql.should be_like(%Q{
              SELECT "users"."id", "users"."name"
              FROM "users"
              WHERE asdf
            })
          end
        end
      end
    end
  end
end