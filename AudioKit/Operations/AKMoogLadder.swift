//
//  AKMoogLadder.swift
//  AudioKit
//
//  Autogenerated by scripts by Aurelius Prochazka on 9/10/15.
//  Copyright (c) 2015 Aurelius Prochazka. All rights reserved.
//

import Foundation

/** Moog Ladder Filter

Moog Ladder is an new digital implementation of the Moog ladder filter based on the work of Antti Huovilainen, described in the paper "Non-Linear Digital Implementation of the Moog Ladder Filter" (Proceedings of DaFX04, Univ of Napoli). This implementation is probably a more accurate digital representation of the original analogue filter.
*/
@objc class AKMoogLadder : AKParameter {

    // MARK: - Properties

    private var moogladder = UnsafeMutablePointer<sp_moogladder>.alloc(1)

    private var input = AKParameter()


    /** Filter cutoff frequency. [Default Value: 1000] */
    var cutoffFrequency: AKParameter = akp(1000) {
        didSet { cutoffFrequency.bind(&moogladder.memory.freq) }
    }

    /** Resonance, generally < 1, but not limited to it. Higher than 1 resonance values might cause aliasing, analogue synths generally allow resonances to be above 1. [Default Value: 0.5] */
    var resonance: AKParameter = akp(0.5) {
        didSet { resonance.bind(&moogladder.memory.res) }
    }


    // MARK: - Initializers

    /** Instantiates the filter with default values */
    init(input sourceInput: AKParameter)
    {
        super.init()
        input = sourceInput
        setup()
        bindAll()
    }

    /**
    Instantiates the filter with all values

    -parameter input Input audio signal. 
    -parameter cutoffFrequency Filter cutoff frequency. [Default Value: 1000]
    -parameter resonance Resonance, generally < 1, but not limited to it. Higher than 1 resonance values might cause aliasing, analogue synths generally allow resonances to be above 1. [Default Value: 0.5]
    */
    convenience init(
        input           sourceInput: AKParameter,
        cutoffFrequency freqInput:   AKParameter,
        resonance       resInput:    AKParameter)
    {
        self.init(input: sourceInput)
        cutoffFrequency = freqInput
        resonance       = resInput

        bindAll()
    }

    // MARK: - Internals

    /** Bind every property to the internal filter */
    internal func bindAll() {
        cutoffFrequency.bind(&moogladder.memory.freq)
        resonance      .bind(&moogladder.memory.res)
    }

    /** Internal set up function */
    internal func setup() {
        sp_moogladder_create(&moogladder)
        sp_moogladder_init(AKManager.sharedManager.data, moogladder)
    }

    /** Computation of the next value */
    override func compute() {
        sp_moogladder_compute(AKManager.sharedManager.data, moogladder, &(input.leftOutput), &leftOutput);
        rightOutput = leftOutput
    }

    /** Release of memory */
    override func teardown() {
        sp_moogladder_destroy(&moogladder)
    }
}
