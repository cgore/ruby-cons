# -*- Coding: utf-8 -*-

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

GEM_NAME="cons"

def is_valid_version(version)
  version =~ /\d+\.\d+\.\d+/
end

def git_tag_exists(tag)
  `git tag|grep #{tag}`.length > 0
end

def version_in_gemspec version
  `grep #{version} #{GEM_NAME}.gemspec`.length > 0
end

def gemfile version
  "#{GEM_NAME}-#{version}.gem"
end

def gem_was_built version
  Dir.entries(".").include? gemfile version
end

task :gem, [:version] do |t, args|
  version = args.version
  raise ArgumentError, "invalid version" if not is_valid_version version
  tag = "v#{version}"
  raise ArgumentError, "tag already exists" if git_tag_exists tag
  raise RuntimeError, "update #{GEM_NAME}.gemspec" if not version_in_gemspec version
  `gem build #{GEM_NAME}.gemspec`
  raise RuntimeError, "failed to build gem" if not gem_was_built version
  `gem push #{gemfile version}`
  `mv #{gemfile version} gem-builds/`
  `git add .`
  `git commit -m "Building gem version #{version}"`
  `git push`
  `git tag #{tag}`
  `git push --tags`
end
