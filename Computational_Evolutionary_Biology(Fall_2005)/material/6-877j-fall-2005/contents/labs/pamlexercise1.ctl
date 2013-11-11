      seqfile = paml_gstd1_seqfile.txt   * sequence data filename (replace with yours)
      outfile = results.txt   * main result file name (must be to a writeable dir)

        noisy = 9      * 0,1,2,3,9: how much rubbish on the screen
      verbose = 1      * 1: detailed output 0: concise output
      runmode = -2     * -2:pairwise

      seqtype = 1      * 1: use codons (ie, assume nucleotide triplets)
    CodonFreq = 3      * 0: equal codon freq, 1:F1X4, 2:F3X4, 3:F61
        model = 0      * 0: one rate in all lineages
      NSsites = 0      * 0: one dN/dS ratio; 1: neutral; 2: positive
        icode = 0      * 0: universal genetic code; 1: mammalian

    fix_kappa = 0      * 1:kappa (transversion rate) fixed, 0:kappa to be estimated
        kappa = 2      * initial or fixed kappa value

    fix_omega = 1      * 1:omega fixed, 0:omega to be estimated 
        omega = 0.001  * 1st fixed omega value *comment this out for subsequent runs*
       
       *alternate fixed omega values - uncomment each in turn for each subsequent run
       *omega = 0.005  * 2nd fixed value 
       *omega = 0.01   * 3rd fixed value
       *omega = 0.05   * 4th fixed value
       *omega = 0.10   * 5th fixed value
       *omega = 0.20   * 6th fixed value
       *omega = 0.40   * 7th fixed value
       *omega = 0.80   * 8th fixed value
       *omega = 1.60   * 9th fixed value
       *omega = 2.00   * 10th fixed value
       

