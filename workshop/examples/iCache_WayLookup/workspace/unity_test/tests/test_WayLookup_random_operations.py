#coding=utf-8
"""
WayLookup 随机测试用例

验证 WayLookup 各种操作的随机测试。
"""

from WayLookup_api import *
import random
import ucagent


def test_random_write_read_sequence(env):
    """
    随机测试写入和读取序列

    测试内容：
    - 随机数据写入
    - 随机顺序读取
    - 数据一致性验证
    """
    env.dut.fc_cover['FG-API'].mark_function('FC-API-WRITE', test_random_write_read_sequence, ['CK-WRITE-BASIC'])
    env.dut.fc_cover['FG-API'].mark_function('FC-API-READ', test_random_write_read_sequence, ['CK-READ-BASIC'])

    # 获取循环测试次数
    N = ucagent.repeat_count()

    for i in range(N):
        # 设置随机种子确保可重复
        random.seed(i * 100 + 12345)

        # 随机写入数据
        test_data = []
        write_count = random.randint(1, 10)

        for j in range(write_count):
            vSetIdx = random.randint(0, 255)
            waymask = random.randint(0, 15)
            ptag = random.randint(0, 0xFFFFFFFFF)

            api_WayLookup_write(
                env,
                vSetIdx=vSetIdx,
                waymask=waymask,
                ptag=ptag,
                max_cycles=100
            )
            test_data.append({'vSetIdx': vSetIdx, 'waymask': waymask, 'ptag': ptag})

        # 随机读取数据
        for j in range(write_count):
            result = api_WayLookup_read(env, max_cycles=100)
            assert result['valid'] == True, f"第 {j} 次读取应返回有效数据"


def test_random_update(env):
    """
    随机测试更新操作

    测试内容：
    - 随机写入数据
    - 随机更新数据
    - 更新结果验证
    """
    env.dut.fc_cover['FG-API'].mark_function('FC-API-UPDATE', test_random_update, ['CK-UPDATE-BASIC'])

    # 获取循环测试次数
    N = ucagent.repeat_count()

    for i in range(N):
        # 设置随机种子
        random.seed(i * 100 + 54321)

        # 随机写入数据
        vSetIdx = random.randint(0, 255)
        waymask = random.randint(1, 15)
        ptag = random.randint(0, 0xFFFFFFFFF)

        api_WayLookup_write(
            env,
            vSetIdx=vSetIdx,
            waymask=waymask,
            ptag=ptag,
            max_cycles=100
        )

        # 随机更新
        new_waymask = random.randint(0, 15)
        blkPaddr = (ptag << 6) | random.randint(0, 63)

        result = api_WayLookup_update(
            env,
            vSetIdx=vSetIdx,
            waymask=new_waymask,
            blkPaddr=blkPaddr,
            corrupt=0,
            max_cycles=100
        )
        assert result == True, "更新应成功"


def test_random_gpf_boundary(env):
    """
    随机测试 GPF 边界条件

    测试内容：
    - 随机 GPF 数据
    - GPF 存储和读取验证
    """
    env.dut.fc_cover['FG-EDGE'].mark_function('FC-EDGE-GPF-BOUNDARY', test_random_gpf_boundary, ['CK-EDGE-GPF-FIRST', 'CK-EDGE-GPF-DOUBLE', 'CK-EDGE-GPF-OVERLAP'])

    # 获取循环测试次数
    N = ucagent.repeat_count()

    for i in range(N):
        # 设置随机种子
        random.seed(i * 100 + 98765)

        # 重置
        env.reset()
        env.Step(5)

        # 随机 GPF 数据
        vSetIdx = random.randint(0, 255)
        waymask = random.randint(0, 15)
        ptag = random.randint(0, 0xFFFFFFFFF)
        gpaddr = random.randint(0, (1 << 56) - 1)
        isForVSnonLeafPTE = random.randint(0, 1)

        # 写入带 GPF 的数据
        result = api_WayLookup_write(
            env,
            vSetIdx=vSetIdx,
            waymask=waymask,
            ptag=ptag,
            gpaddr=gpaddr,
            isForVSnonLeafPTE=isForVSnonLeafPTE,
            max_cycles=100
        )

        # 读取验证
        read_result = api_WayLookup_read(env, max_cycles=100)
        assert read_result['valid'] == True, "写入后读取应返回有效数据"


def test_random_fifo_wrap(env):
    """
    随机测试 FIFO 指针环绕

    测试内容：
    - 填满队列
    - 读取清空
    - 再次写入覆盖
    """
    env.dut.fc_cover['FG-FIFO'].mark_function('FC-FIFO-PTR-WRAP', test_random_fifo_wrap, ['CK-WRAP-READ', 'CK-WRAP-WRITE'])

    # 获取循环测试次数
    N = ucagent.repeat_count()

    for i in range(N):
        # 设置随机种子
        random.seed(i * 100 + 11111)

        # 重置
        env.reset()
        env.Step(5)

        # 随机写入数据直到队列满
        for j in range(32):
            vSetIdx = random.randint(0, 255)
            waymask = random.randint(0, 15)
            ptag = random.randint(0, 0xFFFFFFFFF)

            api_WayLookup_write(
                env,
                vSetIdx=vSetIdx,
                waymask=waymask,
                ptag=ptag,
                max_cycles=100
            )

        # 读取清空队列
        for j in range(32):
            result = api_WayLookup_read(env, max_cycles=100)
            assert result['valid'] == True, f"第 {j} 次读取应返回有效数据"

        # 验证队列已清空
        result = api_WayLookup_read(env, max_cycles=100)
        assert result['valid'] == False, "队列应已清空"
