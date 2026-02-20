class FlatcamEvo < Formula
  include Language::Python::Virtualenv
  desc "2D Computer-Aided PCB Manufacturing (patched fork)"
  homepage "https://github.com/KP-Krisnop/flatcam-evo"
  url "https://github.com/KP-Krisnop/flatcam-evo.git",
      branch: "main",
      revision: "3880e86a30e2704939de403b6fcde3e14af21a52"
  version "8.9.95"

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
    inreplace "requirements.txt", "numpy>=1.16,<2.0", "numpy>=1.16, <2.0"
    system libexec/"bin/pip", "install",
           "--no-binary", "pillow",
           "-r", "requirements.txt"
    libexec.install Dir["*.py", "appCommon", "appEditors", "appGUI",
                        "appHandlers", "appObjects", "appParsers", "appPlugins",
                        "assets", "config", "descartes", "doc", "libs", "locale",
                        "locale_template", "preprocessors", "tclCommands", "Utils"]
    bin.install_symlink libexec/"flatcam.py" => "flatcam"
    system "chmod", "+x", libexec/"flatcam.py"
    system "chmod", "+x", bin/"flatcam"
  end

  test do
    system "true"
  end
end
