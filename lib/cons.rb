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

  alias first car
  alias first= car=
  alias rest cdr
  alias rest= cdr=

  def nthcdr n
    if not n.kind_of? Integer or n < 0
      raise ArgumentError, "n for nthcdr must be a non-negative integer"
    elsif n == 1
      self
    elsif n > 1
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

  def nth_eq(n, value)
    i = nthcdr(n)
    if i.nil?
      raise RuntimeError
    else
      nthcdr(n).car= value
    end
  end

  def first
    car
  end

  def first_eq value
    @car = value
  end

  [[:second, 2],
   [:third, 3],
   [:fourth, 4],
   [:fifth, 5],
   [:sixth, 6],
   [:seventh, 7],
   [:eighth, 8],
   [:ninth, 9],
   [:tenth, 10]].each do |fname, i|
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

  class << self
    def from_array array, initial=true
      car, *cdr = array
      if car.nil?
        if initial
          self[nil, nil]
        else
          nil
        end
      else
        self[car, from_array(cdr, false)]
      end
    end

    def [] car=nil, cdr=nil
      new car, cdr
    end
  end
end
