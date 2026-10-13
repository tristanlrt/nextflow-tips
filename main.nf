process download {
    container 'evolbioinfo/ubuntu:v24.04'
    output:
    path "ref.nw.gz"
    script:
    """
    wget https://booster.pasteur.fr/static/files/primates/ref.nw.gz
    """
}

process listTips {
    container 'evolbioinfo/gotree:v0.4.1a'
    publishDir "results"
    input:
    path tree
    output:
    path "tips.txt"
    script:
    """
    gotree stats tips -i ${tree} > tips.txt
    """
}

workflow {
    tips = listTips(download())
    tips.splitCsv(header: true, sep: '\t')
        .count()
        .view { n -> "Number of tips: ${n}" }
}
