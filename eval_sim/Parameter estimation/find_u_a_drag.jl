
using PyPlot
using JLD

function main(code::AbstractString)
    log_path_record = "$(homedir())/open_loop/output-record-$(code).jld"
    d_rec = load(log_path_record)
    L_b = 0.125

    imu_meas    = d_rec["imu_meas"]
    gps_meas    = d_rec["gps_meas"]
    cmd_log     = d_rec["cmd_log"]
    cmd_pwm_log = d_rec["cmd_pwm_log"]
    vel_est     = d_rec["vel_est"]
    pos_info    = d_rec["pos_info"]

    t0 = max(cmd_pwm_log.t[1],vel_est.t[1],imu_meas.t[1])
    t_end = min(cmd_pwm_log.t[end],vel_est.t[end],imu_meas.t[end])

    t = t0+0.1:.02:t_end-0.1
    v = zeros(length(t))
    cmd = zeros(length(t))

    for i=1:length(t)
        if cmd_log.z[t[i].>cmd_log.t,1][end] > 0 && vel_est.z[t[i].>vel_est.t][end] > 0.2
            v[i] = vel_est.z[t[i].>vel_est.t][end]
            cmd[i] = cmd_log.z[t[i].>cmd_log.t,1][end]
        end
    end
    #plot(cmd,v)
    plot(cmd./v,"*")
    grid("on")
end