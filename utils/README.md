# Translating NLP Resources into TAGL

TAGLize the best NLP resources available into a `tagd:nlp` tagspace.

For each NLP resource:

## Steps 

1. Download resource into `docs/`
  * provide a meaningful filename and subdir if needed.
  * document how the resource was obtained (URL)
  * what license does it fall under - how freely can we use it in tagd?

2. Convert from **input format** to a formal text format (machine parsable)
   and place in `assets/`. Test and verify asset.

   Example:
      From: `docs/penn_treebank_pos.html`
      Process: Human ETL
      Extracted: `assets/penn-treebank-pos.tsv`

   Create `utils/` to help analyze, prioritize or bootstrap the TAGL translation process.
   For example, reverse frequency counts of words/tokens that will become consituents of tags.

   Verify: test/verify asset and edit if needed

3. Generate a TAGL file (tagspace) from the parsed asset

    Example
    ```bash
	utils/tsv-to-tagl.pl tagd:nlp assets/penn-treebank-pos.tsv \
        > tagl/penn-treebank-pos.tagl
    ```
