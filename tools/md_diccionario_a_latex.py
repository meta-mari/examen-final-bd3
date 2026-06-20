from pathlib import Path
import re

src = Path("08_diccionario_datos/01_diccionario_datos.md")
dst = Path("08_diccionario_datos/01_diccionario_datos_latex.tex")

def esc_basic(s: str) -> str:
    return (
        s.replace("\\", r"\textbackslash{}")
         .replace("&", r"\&")
         .replace("%", r"\%")
         .replace("$", r"\$")
         .replace("#", r"\#")
         .replace("_", r"\_")
         .replace("{", r"\{")
         .replace("}", r"\}")
         .replace("~", r"\textasciitilde{}")
         .replace("^", r"\textasciicircum{}")
         .replace("<", r"\textless{}")
         .replace(">", r"\textgreater{}")
    )

def esc(s: str) -> str:
    s = s.strip()

    placeholders = {}

    def protect_code(m):
        key = f"@@CODE{len(placeholders)}@@"
        placeholders[key] = r"\texttt{" + esc_basic(m.group(1)) + "}"
        return key

    def protect_bold(m):
        key = f"@@BOLD{len(placeholders)}@@"
        placeholders[key] = r"\textbf{" + esc_basic(m.group(1)) + "}"
        return key

    s = re.sub(r"`([^`]+)`", protect_code, s)
    s = re.sub(r"\*\*([^*]+)\*\*", protect_bold, s)

    s = esc_basic(s)

    for key, val in placeholders.items():
        s = s.replace(esc_basic(key), val)

    return s

def split_md_row(line: str):
    line = line.strip()
    if line.startswith("|"):
        line = line[1:]
    if line.endswith("|"):
        line = line[:-1]
    return [c.strip() for c in line.split("|")]

def is_separator(line: str):
    cells = split_md_row(line)
    return cells and all(re.fullmatch(r":?-{3,}:?", c.strip()) for c in cells)

lines = src.read_text(encoding="utf-8").splitlines()
out = []

out.append(r"\begingroup")
out.append(r"\scriptsize")
out.append(r"\setlength{\tabcolsep}{2.5pt}")
out.append(r"\renewcommand{\arraystretch}{1.15}")

i = 0
while i < len(lines):
    line = lines[i]

    if line.startswith("# "):
        out.append(r"\subsection{" + esc(line[2:]) + "}")
        i += 1
        continue

    if line.startswith("## "):
        out.append(r"\subsubsection{" + esc(line[3:]) + "}")
        i += 1
        continue

    if line.startswith("### "):
        out.append(r"\paragraph{" + esc(line[4:]) + r"}\mbox{}\\")
        i += 1
        continue

    if line.strip().startswith("|") and i + 1 < len(lines) and is_separator(lines[i + 1]):
        header = split_md_row(line)
        rows = []
        i += 2

        while i < len(lines) and lines[i].strip().startswith("|"):
            rows.append(split_md_row(lines[i]))
            i += 1

        if len(header) == 5:
            colspec = (
                r"p{0.18\linewidth}"
                r"p{0.18\linewidth}"
                r"p{0.08\linewidth}"
                r"p{0.08\linewidth}"
                r"p{0.36\linewidth}"
            )
        else:
            width = 0.92 / max(1, len(header))
            colspec = "".join([fr"p{{{width:.2f}\linewidth}}" for _ in header])

        out.append(r"\begin{longtable}{" + colspec + "}")
        out.append(r"\toprule")
        out.append(" & ".join(r"\textbf{" + esc(h) + "}" for h in header) + r" \\")
        out.append(r"\midrule")
        out.append(r"\endfirsthead")
        out.append(r"\toprule")
        out.append(" & ".join(r"\textbf{" + esc(h) + "}" for h in header) + r" \\")
        out.append(r"\midrule")
        out.append(r"\endhead")

        for row in rows:
            row = row + [""] * (len(header) - len(row))
            out.append(" & ".join(esc(c) for c in row[:len(header)]) + r" \\")

        out.append(r"\bottomrule")
        out.append(r"\end{longtable}")
        continue

    if line.strip() and line.strip() not in {"---", "***", "___"}:
        out.append(esc(line) + r"\par")
    else:
        out.append("")

    i += 1

out.append(r"\endgroup")

dst.write_text("\n".join(out), encoding="utf-8")
print(f"Generado: {dst}")
