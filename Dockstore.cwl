#!/usr/bin/env cwl-runner

class: CommandLineTool

id: "cgpmap"

label: "CGP BWA-mem mapping flow"

cwlVersion: v1.0

doc: |
  Please use one of the new tools for v3+:

    * [dockstore-cgpmap/cgpmap-bamOut](https://dockstore.org/containers/quay.io%2Fwtsicgp%2Fdockstore-cgpmap%2Fcgpmap-bamOut)
    * [dockstore-cgpmap/cgpmap-cramOut](https://dockstore.org/containers/quay.io%2Fwtsicgp%2Fdockstore-cgpmap%2Fcgpmap-cramOut)

  ![build_status](https://quay.io/repository/wtsicgp/dockstore-cgpmap/status)
  A Docker container for PCAP-core. See the [dockstore-cgpmap](https://github.com/cancerit/dockstore-cgpmap) website for more information.

requirements:
  - class: DockerRequirement
    dockerPull: "quay.io/wtsicgp/dockstore-cgpmap:3.2.0"

hints:
  - class: ResourceRequirement
    coresMin: 1 # works but long, 6 recommended
    ramMin: 15000 # good for WGS human ~30-60x
    outdirMin: 5000000 # unlikely any BAM processing would be possible in less

inputs:
  reference:
    type: File
    doc: "The core reference (fa, fai, dict) as tar.gz"
    inputBinding:
      prefix: -reference
      position: 1
      separate: true

  bwa_idx:
    type: File
    doc: "The BWA indexes in tar.gz"
    inputBinding:
      prefix: -bwa_idx
      position: 2
      separate: true

  sample:
    type: string
    doc: "Sample name to be included in output [B|CR]AM header, also used to name final file"
    inputBinding:
      prefix: -sample
      position: 3
      separate: true

  bwa:
    type: string?
    default: ' -Y -K 100000000'
    doc: "Mapping and output parameters to pass to BWA-mem, see BWA docs, default ' -Y -K 100000000'"
    inputBinding:
      prefix: -bwa
      position: 4
      separate: true
      shellQuote: false

#  groupinfo:
#    type: File?
#    doc: "Readgroup metadata file for FASTQ inputs"
#    inputBinding:
#      prefix: -groupinfo
#      position: 5
#      separate: true

  mmqc:
    type: boolean
    doc: "Apply mismatch QC to reads following duplicate marking."
    inputBinding:
      prefix: -qc
      position: 6

  mmqcfrac:
    type: float?
    default: 0.05
    doc: "Mismatch fraction to set as max before failing a read [0.05]"
    inputBinding:
      prefix: -qcf
      position: 7
      separate: true

  bams_in:
    type:
    - 'null'
    - type: array
      items: File
    doc: "Can be BAM, CRAM, fastq (paired or interleaved), BAM/CRAM can be mixed together but not FASTQ."
    inputBinding:
      position: 8

outputs:
  out_bam:
    type: File
    outputBinding:
      glob: $(inputs.sample).bam

  out_bai:
    type: File
    outputBinding:
      glob: $(inputs.sample).bam.bai

  out_bas:
    type: File
    outputBinding:
      glob: $(inputs.sample).bam.bas

  out_md5:
    type: File
    outputBinding:
      glob: $(inputs.sample).bam.md5

  out_met:
    type: File
    outputBinding:
      glob: $(inputs.sample).bam.met

  out_maptime:
    type: File
    outputBinding:
      glob: $(inputs.sample).bam.maptime

baseCommand: ["/opt/wtsi-cgp/bin/ds-cgpmap.pl"]
