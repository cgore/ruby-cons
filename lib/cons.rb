# -*- coding: utf-8 -*-
# -*- mode: Ruby -*-

# Copyright © 2016, Christopher Mark Gore,
# Soli Deo Gloria,
# All rights reserved.
#
# 2317 South River Road, Saint Charles, Missouri 63303 USA.
# Web: http://cgore.com
# Email: cgore@cgore.com
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
#   * Redistributions of source code must retain the above copyright
#     notice, this list of conditions and the following disclaimer.
#
#   * Redistributions in binary form must reproduce the above copyright
#     notice, this list of conditions and the following disclaimer in the
#     documentation and/or other materials provided with the distribution.
#
#   * Neither the name of Christopher Mark Gore nor the names of other
#     contributors may be used to endorse or promote products derived from
#     this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.

class NilClass
  # http://clhs.lisp.se/Body/f_endp.htm
  def end?
    true
  end

  alias endp end?
end

class Array
  def to_cons
    Cons.from_array self
  end

  class << self
    def from_cons cons
      cons.to_a
    end
  end
end

class Cons
  attr_accessor :car, :cdr

  def initialize car=nil, cdr=nil
    @car, @cdr = car, cdr
  end

  def ==(rhs)
    rhs.kind_of? Cons and car == rhs.car and cdr == rhs.cdr
  end

  def length
    result = 0
    current = self
    while current and current.car and not current.car.nil?
      result += 1
      current = current.cdr
    end
    result
  end

  # Cf. <http://clhs.lisp.se/Body/f_list_l.htm>
  alias list_length length

  alias first car
  alias first= car=
  alias rplaca car=
  alias rest cdr
  alias rest= cdr=
  alias rplacd cdr=

  def nthcdr n
    if not n.kind_of? Integer
      raise ArgumentError, "n for nthcdr must be an integer"
    elsif n <= 0
      self
    elsif n > 0
      if cdr.nil?
        nil
      else
        cdr.nthcdr n-1
      end
    end
  end

  def nth n
    i = nthcdr n
    if i.nil?
      nil
    else
      nthcdr(n).car
    end
  end

  def [] n
    nth n
  end

  # http://clhs.lisp.se/Body/f_endp.htm
  def end?
    @car.nil? and @cdr.nil?
  end

  alias endp end?

  def nth_eq(n, value)
    i = nthcdr(n)
    if i.nil?
      raise RuntimeError
    else
      nthcdr(n).car= value
    end
  end

  def []= n, value
    nth_eq n, value
  end

  def first
    car
  end

  def first_eq value
    @car = value
  end

  [[:second, 1],
   [:third, 2],
   [:fourth, 3],
   [:fifth, 4],
   [:sixth, 5],
   [:seventh, 6],
   [:eighth, 7],
   [:ninth, 8],
   [:tenth, 9]].each do |fname, i|
    class_eval %{
      def #{fname}
        nth #{i}
      end

     def #{fname}=(value)
       nth_eq(#{i}, value)
     end
    }
  end

  ["aa",
   "ad",
   "da",
   "dd",
   "aaa",
   "aad",
   "ada",
   "add",
   "daa",
   "dad",
   "dda",
   "ddd",
   "aaaa",
   "aaad",
   "aada",
   "aadd",
   "adaa",
   "adad",
   "adda",
   "addd",
   "daaa",
   "daad",
   "dada",
   "dadd",
   "ddaa",
   "ddad",
   "ddda",
   "dddd"].each do |middle|
    path = middle.split("").map {|i| "c#{i}r"}.join "."
    fname = "c#{middle}r"
    class_eval %{
      def #{fname}
        #{path}
      end

      def #{fname}= value
        #{path}= value
      end
    }
  end

  def to_a
    if not car or car.nil?
      []
    elsif not cdr or cdr.nil?
      [car]
    else
      [car] + cdr.to_a
    end
  end

  # Returns a copy of list. If list is a dotted list, the resulting list will
  # also be a dotted list.
  #
  # Cf. <http://clhs.lisp.se/Body/f_cp_lis.htm>
  def copy_list
    new_cdr = if cdr.kind_of? Cons
                cdr.copy_list
              else
                cdr
              end
    Cons[@car,new_cdr]
  end

  alias list_copy copy_list

  # Creates a copy of a tree of conses.
  #
  # If tree is not a cons, it is returned; otherwise, the result is a new cons
  # of the results of calling copy-tree on the car and cdr of tree. In other
  # words, all conses in the tree represented by tree are copied recursively,
  # stopping only when non-conses are encountered.
  #
  # copy-tree does not preserve circularities and the sharing of substructure.
  #
  # Cf. <http://clhs.lisp.se/Body/f_cp_tre.htm>
  def copy_tree
    new_car = if car.kind_of? Cons
                car.copy_tree
              else
                car
              end
    new_cdr = if cdr.kind_of? Cons
                cdr.copy_tree
              else
                cdr
              end
    Cons[new_car,new_cdr]
  end

  alias tree_copy copy_tree

  # The the_last method returns the last cdr that is a cons.
  def the_last
    if @cdr.kind_of? Cons
      return @cdr.last
    else
      return self
    end
  end

  # last returns the last n conses (not the last n elements) of list).  If n is
  # zero, the atom that terminates list is returned. If n is greater than or
  # equal to the number of cons cells in list, the result is list.
  #
  # Cf. <http://clhs.lisp.se/Body/f_last.htm>
  def last n=nil
    if n.nil? or n == 1
      return the_last
    elsif n <= 0
      return Cons[]
    else
      return nthcdr length-n
    end
  end

  # The append method returns a new list that is the concatenation of the
  # copies. lists are left unchanged; the list structure of each of lists except
  # the last is copied. The last argument is not copied; it becomes the cdr of
  # the final dotted pair of the concatenation of the preceding lists, or is
  # returned directly if there are no preceding non-empty lists.
  #
  # Cf. <http://clhs.lisp.se/Body/f_append.htm>
  def append list, *rest
    result = self.copy_tree
    if rest.empty? or rest.nil?
      if list.kind_of? Cons
        result.the_last.cdr = list.copy_tree
      else # list is not a list
        result.the_last.cdr = list
      end
      return result
    else
      result.the_last.cdr = list.copy_tree
      return result.append *rest
    end
  end

  # The pop method reads the value of place, remembers the car of the list which
  # was retrieved, writes the cdr of the list back into the place, and finally
  # yields the car of the originally retrieved list.
  #
  # Cf. <http://clhs.lisp.se/Body/m_pop.htm>
  def pop
    result = @car
    n = @cdr
    @car = n.car
    @cdr = n.cdr
    return result
  end

  # push prepends item to the list that is stored in place, stores the resulting
  # list in place, and returns the list.
  #
  # Cf. <http://clhs.lisp.se/Body/m_push.htm>
  def push value
    @cdr = Cons[@car,@cdr]
    @car = value
    return self
  end

  ## Lots of TODOs from the CLHS

  # TODO - (n)butlast - http://clhs.lisp.se/Body/f_butlas.htm
  # TODO - ldiff, tailp - http://clhs.lisp.se/Body/f_ldiffc.htm
  # TODO - list* - http://clhs.lisp.se/Body/f_list_.htm
  # TODO - member, member-if, member-if-not - http://clhs.lisp.se/Body/f_mem_m.htm
  # TODO - nconc - http://clhs.lisp.se/Body/f_nconc.htm
  # TODO - revappend, nreconc - http://clhs.lisp.se/Body/f_revapp.htm
  # TODO - pushnew - http://clhs.lisp.se/Body/m_pshnew.htm
  # TODO - (n)subst, (n)subst-if, (n)subst-if-not - http://clhs.lisp.se/Body/f_substc.htm
  # TODO - (n)sublis - http://clhs.lisp.se/Body/f_sublis.htm

  ## Alist stuff
  # TODO - copy-alist - http://clhs.lisp.se/Body/f_cp_ali.htm
  # TODO - acons - http://clhs.lisp.se/Body/f_acons.htm
  # TODO - assoc, assoc-if, assoc-if-not - http://clhs.lisp.se/Body/f_assocc.htm
  # TODO - pairlis - http://clhs.lisp.se/Body/f_pairli.htm
  # TODO - rassoc, rassoc-if, rassoc-if-not - http://clhs.lisp.se/Body/f_rassoc.htm

  ## Lists as sets stuff
  # TODO - adjoin - http://clhs.lisp.se/Body/f_adjoin.htm
  # TODO - (n)intersection - http://clhs.lisp.se/Body/f_isec_.htm
  # TODO - (n)set-difference - http://clhs.lisp.se/Body/f_set_di.htm
  # TODO - (n)set-exclusive-or - http://clhs.lisp.se/Body/f_set_ex.htm
  # TODO - (n)union - http://clhs.lisp.se/Body/f_unionc.htm
  # TODO - subsetp - http://clhs.lisp.se/Body/f_subset.htm

  class << self
    def from_array array
      car, *cdr = array
      result = current = Cons.new
      while car and not car.nil?
        current.car = car
        current.cdr = Cons.new if cdr and not cdr.empty?
        current = current.cdr
        car, *cdr = cdr
      end
      result
    end

    def [] car=nil, cdr=nil
      new car, cdr
    end
  end
end
