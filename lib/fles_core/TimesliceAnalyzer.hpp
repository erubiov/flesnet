// Copyright 2013 Jan de Cuveland <cmail@cuveland.de>
#pragma once

#include "Timeslice.hpp"
#include "MicrosliceDescriptor.hpp"
#include "interface.h" // crcutil_interface

class TimesliceAnalyzer
{
public:
    TimesliceAnalyzer();
    ~TimesliceAnalyzer();

    bool check_timeslice(const fles::Timeslice& ts);

    std::string statistics() const;
    void reset()
    {
        microslice_count_ = 0;
        content_bytes_ = 0;
    }

    size_t count() const { return timeslice_count_; }

private:
    uint32_t compute_crc(const fles::MicrosliceView m) const;

    bool check_crc(const fles::MicrosliceView m) const;

    bool check_flesnet_pattern(const fles::MicrosliceView m, size_t component);

    bool check_content_pgen(const uint16_t* content, size_t size);

    bool check_cbmnet_frames(const uint16_t* content, size_t size,
                             uint8_t sys_id, uint8_t sys_ver);

    bool check_flib_legacy_pattern(const fles::MicrosliceView m,
                                   size_t /* component */);

    bool check_flib_pattern(const fles::MicrosliceView m);

    bool check_microslice(const fles::MicrosliceView m, size_t component,
                          size_t microslice);

    crcutil_interface::CRC* crc32_engine_ = nullptr;

    size_t timeslice_count_ = 0;
    size_t microslice_count_ = 0;
    size_t content_bytes_ = 0;

    uint8_t frame_number_ = 0;
    uint16_t pgen_sequence_number_ = 0;
    uint32_t flib_pgen_packet_number_ = 0;
};