class FlatcamEvo < Formula
  include Language::Python::Virtualenv

  desc "2D Computer-Aided PCB Manufacturing (patched fork)"
  homepage "https://github.com/KP-Krisnop/flatcam-evo"
  url "https://github.com/KP-Krisnop/flatcam-evo/archive/refs/tags/v8.9.95.1.tar.gz"
  sha256 "6fc6a18198abb83f57c2a40b97f888dbdf8189f6ff26ee2fb2bba3fde54fbaf7"

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
    inreplace "flatcam.py", "\nimport sys", "#!#{libexec}/bin/python3\nimport sys"
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
