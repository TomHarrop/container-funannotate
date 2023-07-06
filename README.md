## container-funannotate

Docker image for `funannotate`.

### Usage

You can download the container from GHCR and use it with Docker or Singularity (Apptainer):

```bash
apptainer exec \
    docker://ghcr.io/tomharrop/container-funannotate:1.8.15_cv1 \
    funannotate check --show-versions
```

By default, funannotate uses the `FUNANNOTATE_DB` environment variable to define the path to the funannotate database. You can provide the path to the database with the `-d` argument to funannotate, or set the environment variable when you run the container

Genemark is installed without a license. You need to get your own license, and bind it to ${HOME}/.gm_key when you run the container.

The following dependencies have issues in funannotate-conda_1.7.4:

- `ete3` isn't installed (see [here](https://github.com/nextgenusfs/funannotate/issues/387#issuecomment-593024593)).
- RepeatMasker isn't installed. Use the [Dfam-consortium/TETools](https://github.com/Dfam-consortium/TETools) Docker image to run RepeatMasker separately.
- `signalp` **can't be installed** because of licensing issues.
- `pslCDnaFilter` isn't installed. It only seems to run if `blat` is used in `funannotate predict` (see [this code](https://github.com/nextgenusfs/funannotate/blob/eac3691b43e177ad452057a3128202491d59ca49/funannotate/predict.py#L460-L461))
- `emapper.py` isn't working because the conda container is missing `gcc`. Run `emapper.py` with [biocontainers/eggnog-mapper](https://quay.io/repository/biocontainers/eggnog-mapper) and provide the results to `funannotate annotate`.

## Other containers

The version tags on `Singularity.funannotate-base` and `Singularity.funannotate-deps` refer to the version of `funannotate` they were built for rather than the software in the containers.

#### Singularity.tetools

Base for funannotate using [Dfam's TE Tools container](https://github.com/Dfam-consortium/TETools).
My singularity recipe pulls the docker image from `dfam/tetools`, adds `trf` and makes the RepeatMasker library directory writeable.

#### Singularity.funannotate-base

Adds the funnanotate dependencies that can be installed from `apt`, `pip` and `cpan` to Singularity.tetools

#### Singularity.funannotate-deps

Manually installs the remaining dependencies into Singularity.funannotate-base

#### Singularity.funannotate

Adds `funannotate` into Singularity.funannotate-deps and sets up environment

#### Singularity.interproscan

A container recipe to run `interproscan` outside `funannotate`. Because the container is 9.3 GB it's not hosted on Singularity Hub. Build it locally, and download and expand the Panther 14.1 database. `interproscan` looks for Panther data in /interproscan/data/panther/14.1, so bind the path to your downloaded Panther database into the interproscan as follows:

```bash
singularity exec \
    --writable-tmpfs \
    -B /path/to/panther:/interproscan/data/panther \
    interproscan_5.44-79.0.sif \
    interproscan.sh \
    -i /interproscan/test_proteins.fasta \
    -f tsv -dp \
    --output-dir test \
    --tempdir temp
```

You can also use the `interproscan` [biocontainer](https://quay.io/repository/biocontainers/interproscan).
