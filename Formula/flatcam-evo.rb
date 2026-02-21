class FlatcamEvo < Formula
  include Language::Python::Virtualenv

  desc "2D Computer-Aided PCB Manufacturing (patched fork)"
  homepage "https://github.com/KP-Krisnop/flatcam-evo"
  url "https://github.com/KP-Krisnop/flatcam-evo/archive/refs/tags/v8.9.95.2.tar.gz"
  sha256 "4f1502e2854dd6ef5c7bebff83d9854b29252ae9b25e3661a33a9d4a1645a4a0"

  depends_on "pkg-config" => :build
  depends_on "freetype"
  depends_on "gdal"
  depends_on "geos"
  depends_on "pyqt"
  depends_on "python-tk"
  depends_on "python@3.11"
  depends_on "qpdf"
  depends_on "spatialindex"

  def install
    virtualenv_create(libexec, "python3.11", without_pip: false)
    inreplace "flatcam.py", /\A/, "#!#{libexec}/bin/python3\n"
    system libexec/"bin/pip", "install",
           "--no-binary", "pillow",
           "-r", "requirements.txt"
    libexec.install Dir["*.py", "appCommon", "appEditors", "appGUI",
                        "appHandlers", "appObjects", "appParsers", "appPlugins",
                        "assets", "config", "descartes", "doc", "libs", "locale",
                        "locale_template", "preprocessors", "tclCommands", "Utils"]
    (libexec/"flatcam.py").chmod(0755)
    bin.install_symlink libexec/"flatcam.py" => "flatcam"
  end

  test do
    system "true"
  end
end
