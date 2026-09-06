#!/usr/bin/env python3
"""Cria uma copia PDF sem metadados pessoais, preservando paginas e objetos."""

from __future__ import annotations

import argparse
from pathlib import Path

from pypdf import PdfReader, PdfWriter


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("origem", type=Path)
    parser.add_argument("destino", type=Path)
    args = parser.parse_args()

    reader = PdfReader(str(args.origem))
    if reader.is_encrypted:
        raise SystemExit("PDF criptografado; normalizacao cancelada.")

    writer = PdfWriter()
    writer.clone_document_from_reader(reader)
    writer.metadata = None
    writer.add_metadata(
        {
            "/Title": "Manual do Usuario - CMS GAIATEC",
            "/Subject": "Manual canonico do CMS GAIATEC",
        }
    )

    args.destino.parent.mkdir(parents=True, exist_ok=True)
    with args.destino.open("wb") as output:
        writer.write(output)

    verified = PdfReader(str(args.destino))
    if len(verified.pages) != len(reader.pages):
        raise SystemExit("Numero de paginas divergente apos normalizacao.")
    print(f"[OK] {len(verified.pages)} paginas preservadas: {args.destino}")


if __name__ == "__main__":
    main()
