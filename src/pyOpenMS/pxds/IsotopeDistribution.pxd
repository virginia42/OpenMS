from libcpp cimport bool
from Types cimport *
from String cimport *
from Peak1D cimport *
from EmpiricalFormula cimport *

cdef extern from "<OpenMS/CHEMISTRY/ISOTOPEDISTRIBUTION/IsotopeDistribution.h>" namespace "OpenMS":

    cdef cppclass IsotopeDistribution:        

        IsotopeDistribution() nogil except +
        IsotopeDistribution(IsotopeDistribution) nogil except + # wrap-ignore

        # overwrites the container which holds the distribution using @p distribution
        void set(libcpp_vector[ Peak1D ]& distribution) nogil except +

        # returns the container which holds the distribution
        libcpp_vector[ Peak1D ]& getContainer() nogil except +

        # returns the maximal weight isotope which is stored in the distribution
        Size getMax() nogil except +

        # returns the minimal weight isotope which is stored in the distribution
        Size getMin() nogil except +

        # returns the size of the distribution which is the number of isotopes in the distribution
        Size size() nogil except +

        # clears the distribution and resets max isotope to 0
        void clear() nogil except +

        # Estimate Peptide Isotopedistribution from weight and number of isotopes that should be reported
        #   Implementation using the averagine model proposed by Senko et al. in

        # Estimate Isotopedistribution from weight, average composition, and number of isotopes that should be reported


        # renormalizes the sum of the probabilities of the isotopes to 1
        void renormalize() nogil except +

        # Trims the right side of the isotope distribution to isotopes with a significant contribution.
        void trimRight(double cutoff) nogil except +

        # Trims the left side of the isotope distribution to isotopes with a significant contribution.
        void trimLeft(double cutoff) nogil except +
        
        void merge(double, double) nogil except +


cdef extern from "<OpenMS/CHEMISTRY/ISOTOPEDISTRIBUTION/IsotopePatternGenerator.h>" namespace "OpenMS":

    cdef cppclass IsotopePatternGenerator:

         # wrap-ignore
         # ABSTRACT class
         # no-pxd-import
         IsotopePatternGenerator() 
         IsotopePatternGenerator(double probability_cutoff) nogil except + 
         IsotopePatternGenerator(IsotopeDistribution) nogil except + # wrap-ignore
         # virtual void run(EmpiricalFormula&) = 0; # wrap-ignore

cdef extern from "<OpenMS/CHEMISTRY/ISOTOPEDISTRIBUTION/CoarseIsotopeDistribution.h>" namespace "OpenMS":

    cdef cppclass CoarseIsotopeDistribution(IsotopePatternGenerator):
        # wrap-inherits:
        #  IsotopePatternGenerator

        CoarseIsotopeDistribution() nogil except + 
        CoarseIsotopeDistribution(Size max_isotope) nogil except +
        CoarseIsotopeDistribution(IsotopeDistribution) nogil except + # wrap-ignore

        IsotopeDistribution run(EmpiricalFormula) nogil except +
        
        # returns the currently set maximum isotope
        Size getMaxIsotope() nogil except +
        
        #  sets the maximal isotope with @p max_isotope
        void setMaxIsotope(Size max_isotope) nogil except +

        # @brief Estimate Peptide Isotopedistribution from weight and number of isotopes that should be reported
        #   "Determination of Monoisotopic Masses and Ion Populations for Large Biomolecules from Resolved Isotopic Distributions"
        IsotopeDistribution estimateFromPeptideWeight(double average_weight) nogil except +

        # Estimate peptide IsotopeDistribution from average weight and exact number of sulfurs
        IsotopeDistribution estimateFromPeptideWeightAndS(double average_weight, UInt S) nogil except +

        # Estimate Nucleotide Isotopedistribution from weight
        IsotopeDistribution estimateFromRNAWeight(double average_weight) nogil except +

        # Estimate Nucleotide Isotopedistribution from weight
        IsotopeDistribution estimateFromDNAWeight(double average_weight) nogil except +

        IsotopeDistribution estimateFromWeightAndComp(double average_weight, double C, double H, double N, double O, double S, double P) nogil except +

        # Estimate IsotopeDistribution from weight, exact number of sulfurs, and average remaining composition
        IsotopeDistribution estimateFromWeightAndCompAndS(double average_weight, UInt S, double C, double H, double N, double O, double P);

        # Estimate peptide fragment IsotopeDistribution from the precursor's average weight,
        # fragment's average weight, and a set of isolated precursor isotopes.
        IsotopeDistribution estimateForFragmentFromPeptideWeight(double average_weight_precursor, double average_weight_fragment, libcpp_set[ unsigned int ]& precursor_isotopes) nogil except +

        # Estimate peptide fragment IsotopeDistribution from the precursor's average weight,
        # number of sulfurs in the precursor, fragment's average weight, number of sulfurs in the fragment,
        # and a set of isolated precursor isotopes.
        IsotopeDistribution estimateForFragmentFromPeptideWeightAndS(double average_weight_precursor, UInt S_precursor, double average_weight_fragment, UInt S_fragment, libcpp_set[ unsigned int ]& precursor_isotopes);

        # Estimate RNA fragment IsotopeDistribution from the precursor's average weight,
        # fragment's average weight, and a set of isolated precursor isotopes.
        IsotopeDistribution estimateForFragmentFromRNAWeight(double average_weight_precursor, double average_weight_fragment, libcpp_set[ unsigned int ]& precursor_isotopes) nogil except +

        # Estimate DNA fragment IsotopeDistribution from the precursor's average weight,
        # fragment's average weight, and a set of isolated precursor isotopes.
        IsotopeDistribution estimateForFragmentFromDNAWeight(double average_weight_precursor, double average_weight_fragment, libcpp_set[ unsigned int ]& precursor_isotopes) nogil except +

        # Estimate fragment IsotopeDistribution from the precursor's average weight,
        # fragment's average weight, a set of isolated precursor isotopes, and average composition
        IsotopeDistribution estimateForFragmentFromWeightAndComp(double average_weight_precursor, double average_weight_fragment, libcpp_set[ unsigned int ]& precursor_isotopes, double C, double H, double N, double O, double S, double P) nogil except +

        # Calculate isotopic distribution for a fragment molecule

        IsotopeDistribution calcFragmentIsotopeDist(IsotopeDistribution& fragment_isotope_dist, IsotopeDistribution& comp_fragment_isotope_dist, libcpp_set[ unsigned int ]& precursor_isotopes) nogil except +

        IsotopeDistribution run(EmpiricalFormula&) nogil except +
