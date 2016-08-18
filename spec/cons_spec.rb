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
# * Redistributions of source code must retain the above copyright
#   notice, this list of conditions and the following disclaimer.
#
# * Redistributions in binary form must reproduce the above copyright
#   notice, this list of conditions and the following disclaimer in the
#   documentation and/or other materials provided with the distribution.
#
# * Neither the name of Christopher Mark Gore nor the names of other
#   contributors may be used to endorse or promote products derived from
#   this software without specific prior written permission.
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

describe Cons do
  describe :initialize do
    it "can be instantiated with no arguments" do
      expect(Cons.new).to be_a Cons
    end

    it "can be instantiated with just a car value" do
      c = Cons.new 1
      expect(c).to be_a Cons
      expect(c.car).to eq 1
    end

    it "can be instantiated with a car and cdr value" do
      c = Cons.new 1, 2
      expect(c).to be_a Cons
      expect(c.car).to eq 1
      expect(c.cdr).to eq 2
    end
  end

  describe :[] do
    it "instantiates a new cons with no arguments" do
      c = Cons[]
      expect(c).to be_a Cons
      expect(c.car).to be_nil
      expect(c.cdr).to be_nil
    end

    it "instantiates a new cons with just a car value" do
      c = Cons[1]
      expect(c).to be_a Cons
      expect(c.car).to eq 1
      expect(c.cdr).to be_nil
    end

    it "instantiates a new cons with a car and cdr value" do
      c = Cons[1,2]
      expect(c).to be_a Cons
      expect(c.car).to eq 1
      expect(c.cdr).to eq 2
    end
  end

  describe :from_array do
    it "works with an empty array" do
    end

    it "works with an array of only one item" do
      c = Cons.from_array [1]
      expect(c.car).to eq 1
      expect(c.cdr).to be_nil
    end

    it "works with an array of multiple items" do
      c = Cons.from_array [1,2,3,4,5]
      expect(c.first).to  eq 1
      expect(c.second).to eq 2
      expect(c.third).to  eq 3
      expect(c.fourth).to eq 4
      expect(c.fifth).to  eq 5
      expect(c.sixth).to be_nil
    end
  end
end
