// --------------------------------------------------------------------------
//                   OpenMS -- Open-Source Mass Spectrometry
// --------------------------------------------------------------------------
// Copyright The OpenMS Team -- Eberhard Karls University Tuebingen,
// ETH Zurich, and Freie Universitaet Berlin 2002-2020.
//
// This software is released under a three-clause BSD license:
//  * Redistributions of source code must retain the above copyright
//    notice, this list of conditions and the following disclaimer.
//  * Redistributions in binary form must reproduce the above copyright
//    notice, this list of conditions and the following disclaimer in the
//    documentation and/or other materials provided with the distribution.
//  * Neither the name of any author or any participating institution
//    may be used to endorse or promote products derived from this software
//    without specific prior written permission.
// For a full list of authors, refer to the file AUTHORS.
// --------------------------------------------------------------------------
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
// ARE DISCLAIMED. IN NO EVENT SHALL ANY OF THE AUTHORS OR THE CONTRIBUTING
// INSTITUTIONS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
// EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
// PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
// OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
// WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
// OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
// ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//
// --------------------------------------------------------------------------
// $Maintainer: Chris Bielow$
// $Authors: Valentin Noske, Vincent Musch$
// --------------------------------------------------------------------------

#include <OpenMS/QC/MQEvidenceExporter.h>/*
#include <string>
#include <fstream>
#include <OpenMS/KERNEL/FeatureMap.h>
#include <OpenMS/KERNEL/Feature.h>
*/
using namespace std;
using namespace OpenMS;


MQEvidence::MQEvidence(const string &file)
{
    file_ = fstream(file, fstream::out);

    //TODO: Header Funktion , die spalten prüft
}

MQEvidence::~MQEvidence() {
    file_.close();
}
/*
std::fstream MQEvidence::getFile() const
{
    return file_;
}*/

void MQEvidence::export_header()
{
    if(!file_.good())
    {
        //TODO: exception
    }
    file_.clear();
    file_ << "Sequenz" << "\t";
}

void MQEvidence::f_export(const FeatureMap &fm) {
    int intensity;
    int charge;
    double rt;
    double mz;
    for (Feature f : fm) {
        intensity = f.getIntensity();
        charge = f.getCharge();
        mz = f.getMZ();
        rt = f.getRT();
        auto v_pepI = f.getPeptideIdentifications();
        auto pepH = v_pepI[0].getHits()[0];
        for (auto pep : v_pepI) {

            pep.sort();
            auto pH = pep.getHits();
            if (pH[0].getScore() > pepH.getScore()) {
                pepH = pH[0];
            }

        }
        double score_pepH = pepH.getScore();
        auto seq = pepH.getSequence();
        pepH.getSequence();


        file_ << seq << "\t" << seq.getNTerminalModificationName() << seq << seq.getCTerminalModificationName() << "\t"
              << charge << "\t" << mz << "\t" << rt << "\t" << score_pepH << "\t" << intensity << "\t";
    }
}
//////////////////////////////////////////////////////////////////////////////////////


void MQEvidence::exportFeatureMapTotxt(const FeatureMap & feature_map) {
    //go trough all features
    for (Feature f : feature_map)
    {
        //Todo: Export row über die Features
        //row funktion

    }
}

