class Slang < Formula
    desc "SystemVerilog compiler and language services"
    homepage "https://sv-lang.com/"
    url "https://github.com/MikePopoloski/slang.git", tag: "v6.0", revision: "7bcff261b46a7c72aef0be3a24b25334d74077ea"
    license "MIT"
    head "https://github.com/MikePopoloski/slang.git"
  
    # assumes macOS with some clang. did not want to require Xcode nor a specific clang via Homebrew, so that you could use either and see if it works, also linux.
    # try gcc on linux
    if OS.mac?
        fails_with :gcc
    end

    depends_on "cmake" => :build
    depends_on "python@3" => :build
    depends_on "ninja" => :build
    depends_on "libffi" => :build
    depends_on "boost"
    depends_on "fmt"
    depends_on "pkg-config" => :build
    depends_on "catch2"

    option "with-pylib", "Build python bindings"
    depends_on "pybind11" if build.with? "pylib"
    depends_on "mimalloc" if build.without? "pylib"
  
    def install 
      pylib_args = ["-D" "SLANG_INCLUDE_PYLIB=ON", "-D" "SLANG_USE_MIMALLOC=OFF"] if build.with? "pylib"
      cmake_args = ["-D" "SLANG_INCLUDE_TESTS=OFF", *pylib_args, *std_cmake_args]

      system "cmake", "-S" ".", "-B" "build", "-G" "Ninja", "-D" "HOMEBREW_ALLOW_FETCHCONTENT=ON", *cmake_args
      system "cmake", "--build", "build", "--parallel", "#{ENV.make_jobs}"
      system "cmake", "--install", "build", "--strip", "--prefix", prefix
    end
  
    test do
      system "#{bin}/slang", "--version"
    end
end
  