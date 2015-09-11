//
//  AKHighPassFilter.swift
//  AudioKit
//
//  Autogenerated by scripts by Aurelius Prochazka on 9/10/15.
//  Copyright (c) 2015 Aurelius Prochazka. All rights reserved.
//

import Foundation

/** A first-order recursive high-pass filter with variable frequency response.

A complement to the AKLowPassFilter.
*/
@objc class AKHighPassFilter : AKParameter {

    // MARK: - Properties

    private var atone = UnsafeMutablePointer<sp_atone>.alloc(1)

    private var input = AKParameter()


    /** This is the response curve's half power point (aka cutoff frequency). [Default Value: 1000] */
    var cutoffFrequency: AKParameter = akp(1000) {
        didSet { cutoffFrequency.bind(&atone.memory.hp) }
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
    -parameter cutoffFrequency This is the response curve's half power point (aka cutoff frequency). [Default Value: 1000]
    */
    convenience init(
        input           sourceInput: AKParameter,
        cutoffFrequency hpInput:     AKParameter)
    {
        self.init(input: sourceInput)
        cutoffFrequency = hpInput

        bindAll()
    }

    // MARK: - Internals

    /** Bind every property to the internal filter */
    internal func bindAll() {
        cutoffFrequency.bind(&atone.memory.hp)
    }

    /** Internal set up function */
    internal func setup() {
        sp_atone_create(&atone)
        sp_atone_init(AKManager.sharedManager.data, atone)
    }

    /** Computation of the next value */
    override func compute() {
        sp_atone_compute(AKManager.sharedManager.data, atone, &(input.leftOutput), &leftOutput);
        rightOutput = leftOutput
    }

    /** Release of memory */
    override func teardown() {
        sp_atone_destroy(&atone)
    }
}
